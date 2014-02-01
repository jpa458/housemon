ng = angular.module 'myApp'

ng.config ($stateProvider, navbarProvider) ->
  $stateProvider.state 'dashboard',
    url: '/dashboard'
    templateUrl: 'dashboard/dashboard.html'
    controller: 'DashboardCtrl'
  navbarProvider.add '/dashboard', 'Dashboard', 13

ng.controller 'DashboardCtrl', ($scope, primus, host, startStatusValueBroadcast) ->
  startStatusValueBroadcast($scope, primus, host)