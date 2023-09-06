/* 
  ┌─────────────────────────────────────────────────────────────────────────────┐
  │     রেফারেন্স হবে মডেল এ প্রদত্ত নাম ;                                         │
  │     উদাহরণ ঃ mongoose.model("station", stationSchema);                      │
  │     এখানে রেফারেন্স হবে ঃ "station"                                           │
  │     Tutorial : https://vegibit.com/mongoose-relationships-tutorial/         │
  └─────────────────────────────────────────────────────────────────────────────┘
 */

const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const stationSchema = new Schema(
  {
    stationname: String,
    cityid: {
      type: Schema.Types.ObjectId,
      ref: "city",
    },
    stateid: {
      type: Schema.Types.ObjectId,
      ref: "state",
    },
    countryid: {
      type: Schema.Types.ObjectId,
      ref: "country",
    },
    latitude: String,
    longitude: String,
  },
  {
    timestamps: {
      createdAt: "createdAt",
      updatedAt: "updatedAt",
    },
  }
);
const stationModel = mongoose.model("station", stationSchema);
module.exports = stationModel;
