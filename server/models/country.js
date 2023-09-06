const mongoose = require("mongoose");

module.exports = mongoose.model(
  "country",
  new mongoose.Schema(
    {
      countryname: { type: String, required: true, unique: true },
      shortname: { type: String, required: true, unique: true },
      dialcode: { type: String, required: true, unique: true },
      activestatus: { type: String, required: true, unique: false },
    },
    {
      timestamps: {
        createdAt: "createdAt",
        updatedAt: "updatedAt",
      },
    }
  )
);
