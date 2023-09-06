const jwt = require("jsonwebtoken");
const User = require("../../models/user_model");

exports.checkUser = async function (token) {
  var userResponse;
  try {
    var tokenEmail = jwt.decode(token).email;
    await User.findOne({ email: tokenEmail }).then((data) => {
      if (data) {
        var result = jwt.verify(token, data.key); //decoded if exist
        if (result.email == data.email) {
          userResponse = 1;
        }
      } else {
        userResponse = 0; //means no user found
      }
    });
  } catch (error) {
    //console.log("Error occurs while checking user");
    userResponse = 2;
  }
  return userResponse;
};
