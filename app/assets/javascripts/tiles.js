var ScrabbleKiller = angular.module('ScrabbleKiller', []);

ScrabbleKiller.controller('TileCtrl', ['$scope', '$http',
	function($scope, $http) {

		$scope.play = function(tiles) {
			console.log(tiles);

			$http.get('tiles/play/' + tiles)
			.success(function(data){
				$scope.result = 'you cheater! Play "'+data+'" and you are sure to win';
				console.log(data);
				});
			$scope.tiles = '';
		};
	}
	]);