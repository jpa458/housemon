ng = angular.module 'myApp'

ng.config ($stateProvider) ->
  $stateProvider.state 'admin',
    url: '/admin'
    templateUrl: 'admin/view.html'
    controller: 'AdminCtrl'

ng.controller 'AdminCtrl', ($scope, host) ->
  host('admin_dbinfo').then (res) ->
    $scope.hello = res
