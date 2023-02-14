import 'package:quitanda/src/models/cart_item_model.dart';
import 'package:quitanda/src/models/item_model.dart';

ItemModel maca = ItemModel(
  description:
      "A melhor maçã da região que conta com melhor preço de qualquer quitanda",
  price: 5.5,
  unit: 'kg',
  imgUrl: 'assets/fruits/apple.png',
  itemName: "Maça",
);

ItemModel uva = ItemModel(
  description:
      "A melhor uva da região que conta com melhor preço de qualquer quitanda",
  price: 4,
  unit: 'kg',
  imgUrl: 'assets/fruits/grape.png',
  itemName: "Uva",
);

ItemModel goiaba = ItemModel(
  description:
      "A melhor goiaba da região que conta com melhor preço de qualquer quitanda",
  price: 5.7,
  unit: 'kg',
  imgUrl: 'assets/fruits/guava.png',
  itemName: "Goiaba",
);

ItemModel kiwi = ItemModel(
  description:
      "A melhor kiwi da região que conta com melhor preço de qualquer quitanda",
  price: 6,
  unit: 'kg',
  imgUrl: 'assets/fruits/kiwi.png',
  itemName: "Kiwi",
);

ItemModel manga = ItemModel(
  description:
      "A melhor manga da região que conta com melhor preço de qualquer quitanda",
  price: 1,
  unit: 'kg',
  imgUrl: 'assets/fruits/mango.png',
  itemName: "Manga",
);

ItemModel papaya = ItemModel(
  description:
      "A melhor papaya da região que conta com melhor preço de qualquer quitanda",
  price: 2.7,
  unit: 'kg',
  imgUrl: 'assets/fruits/papaya.png',
  itemName: "Papaya",
);

List<ItemModel> items = [
  maca,
  uva,
  kiwi,
  papaya,
  goiaba,
  manga,
];

List<String> categories = [
  "Frutas",
  "Verduras",
  "Legumes",
  "Carnes",
  "Temperos",
  "Cereais",
];

List<CartItemModel> cartItems = [
  CartItemModel(
    item: maca,
    quantity: 2,
  ),
  CartItemModel(
    item: manga,
    quantity: 1,
  ),
  CartItemModel(
    item: goiaba,
    quantity: 3,
  ),
];
