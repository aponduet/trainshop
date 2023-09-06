const mongoose = require("mongoose");
mongoose.Promise = global.Promise;
require("dotenv").config();

const database_connection = mongoose
  .connect(process.env.MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => {
    console.log("Database connection Success.");
  })
  .catch((err) => {
    console.error("Mongo Connection Error", err);
  });

module.exports = database_connection;

//Connect Muntiple databases
// function createMuntipleConnection(uri) {
//   const db = mongoose.createConnection(uri, {
//     useNewUrlParser: true,
//     useUnifiedTopology: true,
//   });
//   db.on("error", function (error) {
//     console.log(`MongoDB :: connection ${this.name} ${JSON.stringify(error)}`);
//     db.close().catch(() =>
//       console.log(`MongoDB :: Failed to Close connection ${this.name}`)
//     );
//   });
//   db.on("connected", function () {
//     mongoose.set("debug", (col, method, query, doc) =>
//       console.log(
//         `MongoDB :: ${this.conn.name} ${col}.${method}(${JSON.stringify(
//           query
//         )}, ${JSON.stringify(doc)})`
//       )
//     );
//     console.log(`MongoDB :: Connected ${this.name}`);
//   });
//   db.on("disconnected", function () {
//     console.log(`MongoDB :: Disconnected ${this.name}`);
//   });
//   return db;
// }

// //How to use
// const DB_trainjourney = createMuntipleConnection(process.env.MONGODB_URI1);
// const DB_trainshop = createMuntipleConnection(process.env.MONGODB_URI2);

// module.exports = {
//   DB_trainjourney,
//   DB_trainshop,
// };
