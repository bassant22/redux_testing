import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_testing/data/model/nowplaying_data.dart';
import 'package:redux_testing/features/favorite_movies/favorite_view_model.dart';
import 'package:redux_testing/redux/app/app_state.dart';

class FavoriteIcon extends StatelessWidget {
  MoviesModel movie;

  FavoriteIcon(this.movie);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MovieFavoriteViewModel>(
      distinct: true,
      converter: (store) => MovieFavoriteViewModel.fromStore(store),
      builder: (_, viewModel) =>
          FavoriteIconContent(
              viewModel, movie
          ),
    );
  }
}

class FavoriteIconContent extends StatefulWidget {

  final MovieFavoriteViewModel viewModel;
  MoviesModel movie;


  FavoriteIconContent(this.viewModel, this.movie);


  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIconContent> {
  @override
  Widget build(BuildContext context) {
    var favoriteMovies = this.widget.viewModel.favoritesMovie;
    bool flag = false;
    return  !flag? IconButton(
      icon: Icon(Icons.favorite_border,),
      onPressed: () {
        setState(() {
          flag = true;
        });
        for(int i=0 ; i < favoriteMovies.length;i++){
          if ( (favoriteMovies.getAt(i) as MoviesModel).originalTitle == this.widget.movie.originalTitle) {
            return ;
          }
        }
        this.widget.viewModel.addFavorite(this.widget.movie);

      },
    ):IconButton(
      icon: Icon(
        Icons.favorite,
        color: Colors.red,
      ),
      onPressed:(){
        setState(() {
          flag = false;
        });
      },
      iconSize: 30,
    );
  }
}
