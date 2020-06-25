# レディース
ladies = Category.create(name: "レディース")

ladies_tops = ladies.children.create(name: "トップス")
ladies_tops.children.create([
  {name: "Tシャツ/カットソー(半袖/袖なし)"}, 
  {name: "Tシャツ/カットソー(七分/長袖)"}
])