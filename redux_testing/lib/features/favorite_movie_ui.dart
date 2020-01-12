import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:redux_testing/data/model/nowplaying_data.dart';

class FavoriteMovieUi extends StatefulWidget {
  @override
  _FavoriteMovieUiState createState() => _FavoriteMovieUiState();
}
class _FavoriteMovieUiState extends State<FavoriteMovieUi> {
  bool flag = false;
  @override
  Widget build(BuildContext context) {
    final contactsBox = Hive.box('favorite');
    print('............................................SSSSSSSSss $contactsBox');
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _customBar(),
          SizedBox(
            height: 80.0,
          ),
          SizedBox(
            height: 360.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: contactsBox.length,
                itemBuilder: (BuildContext context, int index) {
                  final newFav = contactsBox.getAt(index) as MoviesModel;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                    child: Container(
                        width: 160,

                        child: Column(
                          children: <Widget>[
                            Container( height: 270,child: Image.network(newFav.posterPath)),
                            SizedBox(height: 8,),
                            Text(newFav.originalTitle),
                            !flag
                                ? IconButton(
                                    icon: Icon(
                                      Icons.favorite_border,
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        flag = true;
                                      });
                                    },
                                    iconSize: 30.0,
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                    onPressed:(){
                                      setState(() {
                                        flag = false;
                                      });
                                      contactsBox.deleteAt(index);
                                    },
                                    iconSize: 30,
                                  ),
                          ],
                        )),
                  );
                }),
          ),
        ],
      ),
    );
  }

  _customBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.only(
                    topRight: Radius.elliptical(50, 50),
                    bottomRight: Radius.elliptical(50, 50)),
                shape: BoxShape.rectangle),
            padding: EdgeInsets.only(left: 15.0),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 25.0,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        Container(
          padding: EdgeInsets.only(right: 80.0),
          child: Text(
            "Your Favorite Movies",
            style: GoogleFonts.caveat(
              textStyle: TextStyle(color: Colors.white, fontSize: 25.0),
            ),
          ),
        ),
      ],
    );
  }

  _favoriteMovieList() {
}
}
