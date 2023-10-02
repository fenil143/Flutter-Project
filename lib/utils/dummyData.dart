// import "../model/adSliderModel.dart";
import "../model/eventModel.dart";
import "../model/menuModel.dart";
import "../model/placeModel.dart";

List<MenuModel> menus = [
  MenuModel(name: "Sports", asset: "assets/images/icons/running.svg"),
  MenuModel(name: "Activity", asset: "assets/images/icons/flag.svg"),
  MenuModel(name: "Theaters", asset: "assets/images/icons/film.svg"),
  MenuModel(name: "Event", asset: "assets/images/icons/spotlights.svg"),
  MenuModel(name: "Plays", asset: "assets/images/icons/theater_masks.svg"),
  MenuModel(name: "Monum", asset: "assets/images/icons/pyramid.svg"),
];

List<EventModel> events = [
  EventModel(
    title: "Happy Halloween 2K19",
    description: "Music show",
    date: "date",
    bannerUrl:
        "https://i0.wp.com/nvpmart.in/wp-content/uploads/2023/02/EventManagement.jpg?fit=1053%2C625&ssl=1",
  ),
  EventModel(
    title: "Music DJ king monger Sert...",
    description: "Music show",
    date: "date",
    bannerUrl:
        "https://i0.wp.com/nvpmart.in/wp-content/uploads/2023/02/EventManagement.jpg?fit=1053%2C625&ssl=1",
  ),
  EventModel(
    title: "Summer sounds festiva..",
    description: "Comedy show",
    date: "date",
    bannerUrl:
        "https://i0.wp.com/nvpmart.in/wp-content/uploads/2023/02/EventManagement.jpg?fit=1053%2C625&ssl=1",
  ),
  EventModel(
    title: "Happy Halloween 2K19",
    description: "Music show",
    bannerUrl:
        "https://i0.wp.com/nvpmart.in/wp-content/uploads/2023/02/EventManagement.jpg?fit=1053%2C625&ssl=1",
    date: "date",
  ),
];

List<PlaceModel> places = [
  PlaceModel(
    title: "Bigil",
    description: "description",
    like: 84,
    bannerUrl: "assets/images/movies/movie1.jpg",
  ),
  PlaceModel(
    title: "Kaithi",
    description: "description",
    like: 84,
    bannerUrl: "assets/images/movies/movie2.jpg",
  ),
  PlaceModel(
    title: "Asuran",
    description: "description",
    like: 84,
    bannerUrl: "assets/images/movies/movie3.jpg",
  ),
  PlaceModel(
    title: "Sarkar",
    description: "description",
    like: 84,
    bannerUrl: "assets/images/movies/movie4.jpg",
  ),
];
