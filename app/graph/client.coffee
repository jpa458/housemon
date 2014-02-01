ng = angular.module 'myApp'

ng.config ($stateProvider, navbarProvider) ->
  $stateProvider.state 'graph',
    url: '/graph'
    templateUrl: 'graph/graph.html'
    controller: 'GraphCtrl'
  navbarProvider.add '/graph', 'Graph', 14


ng.factory 'startStatusValueBroadcast', () ->
    ($scope, primus, host) ->
      host('status_driverinfo').then (info) ->
        # FIXME: this may get called a bit too often, memoise?
        lookup = (row) ->
          out = info[row.type]?.out
          # If out is an array, then lookup via tag (without optional '-' suffix)
          if out? and Array.isArray out
            subtype = row.tag.replace /-.*##/, ''
            out = info[row.type]?[subtype]
          out?[row.name] ? {}

        $scope.status = primus.live $scope, 'status', (row) ->
          rowInfo = lookup row
          if rowInfo.factor
            row.value *= rowInfo.factor
          if rowInfo.scale < 0
            row.value *= Math.pow 10, -rowInfo.scale
          else if rowInfo.scale >= 0
            row.value /= Math.pow 10, rowInfo.scale
            row.value = row.value.toFixed rowInfo.scale
          
          $scope.graphableItems?[row.key] = row      
          x = new Date(row.time)
          $scope.$broadcast 'newGraphData', row.key, [x, row.value]    
    


ng.controller 'GraphCtrl', ($scope, primus, host, startStatusValueBroadcast) ->
  #associative array (ex. key :'homepower/rf12-9/p1') of items that have graphs, sourced from $scope.status
  #we hold a copy : if the dropdown is sourced directly from primus it gets reset every time new data arrives.
  $scope.graphableItems = {}
  startStatusValueBroadcast($scope, primus, host)
    
  $scope.update = () ->
    $scope.$broadcast 'changeGraph', $scope.selectedGraphItem


ng.directive 'ghgraph',(host) ->
  restrict: 'E' 
  scope:  
      val: '='
  link: ($scope, element, attrs)->
      
      $scope.populate = (key) -> 
        host('graphData', key).then (res) -> 
          $scope.data = res
          $scope.data.sort (a,b) -> 
            parseInt(a[0]) - parseInt(b[0]) 
          for rec in $scope.data
              rec[0]=new Date(rec[0])
          $scope.graph.updateOptions( {'file': $scope.data, 'title': key})  
      
      $scope.data = []
      $scope.graph = new Dygraph element[0],$scope.data,
                      width: 480
                      height: 240
                      labels: ['Time', 'Value']
                      #showRangeSelector: true
                      rangeSelectorHeight: 30
                      rangeSelectorPlotStrokeColor: 'gray'
                      rangeSelectorPlotFillColor: 'gray'
                      drawPoints: true
      if attrs.key
        $scope.populate attrs.key             

      $scope.$on 'newGraphData', (event, args...) ->
        if attrs.key == args[0]
          $scope.data.push(args[1])
          $scope.graph.updateOptions( {'file': $scope.data})  
      
      $scope.$on 'changeGraph', (event, args...) ->
        attrs.key = args[0]
        $scope.populate attrs.key

      return