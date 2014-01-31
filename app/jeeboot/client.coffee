ng = angular.module 'myApp'

ng.config ($stateProvider, navbarProvider) ->
  $stateProvider.state 'jeeboot',
    url: '/jeeboot'
    templateUrl: 'jeeboot/view.html'
    controller: 'JeeBootCtrl'
  navbarProvider.add '/jeeboot', 'JeeBoot', 10

ng.controller 'JeeBootCtrl', ($scope, jeebus) ->
  # TODO rewrite these example to use the "hm" service i.s.o. "jeebus"

  $scope.echoTest = ->
    jeebus.send "echoTest!" # send a test message to JB server's stdout
    jeebus.rpc('echo', 'Echo', 'me!').then (r) ->
      $scope.message = r
