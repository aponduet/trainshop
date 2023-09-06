const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const shopSchema = new Schema(
  {
    username: { type: String, required: true },
    shopname: { type: String, required: true, unique: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: false, trim: true },
    otp: { type: Number, trim: true, unique: false },
    key: String,
    jwt: String,
    aboutme: String,
    address: String,
    mobile: String,
    dateofbirth: String,
    facebook: String,
    twitter: String,
    whatsapp: String,
    deliverystation: {
      type: Schema.Types.ObjectId,
      ref: "station",
      required: true,
    },
    country: { type: Schema.Types.ObjectId, ref: "country", required: true },
  },
  {
    timestamps: {
      createdAt: "createdAt",
      updatedAt: "updatedAt",
    },
  }
);
const shopModel = mongoose.model("shop", shopSchema);
module.exports = shopModel;
