const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const productSchema = new Schema(
  {
    name: { type: String, required: true },
    description: String,
    price: String,
    stock: String,
    category: String,
    imageurl: String,
    shopid: {
      type: Schema.Types.ObjectId,
      ref: "shop",
      required: true,
    },
  },
  {
    timestamps: {
      createdAt: "createdAt",
      updatedAt: "updatedAt",
    },
  }
);
const productModel = mongoose.model("product", productSchema);
module.exports = productModel;
