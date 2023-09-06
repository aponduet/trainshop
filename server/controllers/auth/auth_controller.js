const jwt = require("jsonwebtoken");
const { v4: uuidv4 } = require("uuid");
const otpGenerator = require("otp-generator");
const fs = require("fs");
const path = require("path");
const bcrypt = require("bcryptjs");
const OtpTable = require("../../models/otp_model");
const User = require("../../models/shop_model");
const country = require("../../models/country");
const Shop = require("../../models/shop_model");
const stationModel = require("../../models/station_model");
const { response } = require("express");

/*
    .------------------------------.
    |     Status Code Guidlines    |
    '------------------------------'
    Authentication Releted Status Codes
    200 : Data Found
    202 : Data Not Found
    204 : token Expired or Invalid (Auto LogOut and Back to Login)
    404 : User not found. (Auto LogOut and Back to Login)
    501 : No Internet
    503 : No Server
    505 : Bad Request to Server
    205 : Server Error/Data Searching Error.
    */

//Create New user Controller
exports.createshop = async function (req, res) {
  try {
    // Validate request
    if (
      !req.body.username ||
      !req.body.shopname ||
      !req.body.email ||
      !req.body.password ||
      !req.body.countryid ||
      !req.body.deliverystationid
    ) {
      res.status(209).send({ message: "Fields can not be empty!" });
      return;
    }

    await Shop.findOne({ email: req.body.email })
      .then(async function (data) {
        if (data) {
          res.status(202).send({
            message: "Email already in use!!",
          });
          return;
        }
        await Shop.findOne({ shopname: req.body.shopname })
          .then(async (data) => {
            if (data) {
              res.status(202).send({
                message: "Shopname already in use!!",
              });
              return;
            }
            // Create New Shop User
            const payload = { email: req.body.email };
            const KEY = uuidv4();
            const token = jwt.sign(payload, KEY, {
              algorithm: "HS256",
              expiresIn: "10d",
            });
            //Hash the plain password
            const salt = bcrypt.genSaltSync(10);
            const hash = bcrypt.hashSync(req.body.password, salt);

            const Data = new Shop({
              username: req.body.username,
              shopname: req.body.shopname,
              email: req.body.email,
              password: hash,
              key: KEY,
              jwt: token,
              address: "",
              aboutme: "",
              mobile: "",
              dateofbirth: "",
              facebook: "",
              twitter: "",
              whatsapp: "",
              deliverystation: req.body.deliverystationid,
              country: req.body.countryid,
            });

            console.log("Request received in server");

            // Save User in the database
            await Data.save()
              .then((data) => {
                console.log("I am cALLED");
                //Send Token to the user
                if (data) {
                  res.status(200).json({
                    jwt: data.jwt,
                    username: data.username,
                    shopname: data.shopname,
                    userid: data._id,
                    email: data.email,
                    deliverystation: data.deliverystation,
                    countryid: data.countryid,
                  });
                }
              })
              .catch((err) => {
                console.log(err);
                res.status(205).send({
                  message: "Some error occurred while creating the Shop.",
                });
              });
          })
          .catch((err) => {
            console.log("I am called in error");
            res.status(205).send({ message: err.message });
          });
      })
      .catch((err) => {
        res.status(205).send({ message: err.message });
      });
  } catch (error) {
    console.log(error);
  }
};

//User Login Controller
// exports.login = async function(req, res) {
//     // Validate request
//     if (!req.body.email || !req.body.password) {
//       res.status(202).send({ message: "Fields can not be empty!" });
//       return;
//     }

//     await Shop.findOne({email: req.body.email, password: req.body.password})
//     .then( async function(data) {
//       if (data)
//         {
//           try {
//             const result = jwt.verify(data.jwt, data.key); //decoded if Valid
//               if (result.email == data.email) {
//                 res.json({
//                   "jwt": data.jwt,
//                   "username": data.username,
//                   "email": data.email,
//                 });
//                 //console.log('Valid user tocken');
//               }
//           } catch (error) {
//             //If Token Expired
//             const payload = {
//               email : data.email
//             };

//             const KEY = uuidv4();
//             const token = jwt.sign(payload, KEY, {algorithm: 'HS256', expiresIn: "10d"});
//             //Save Secret KEY to the user database
//             const filter = { email: req.body.email};
//             const update = { key: KEY, jwt : token };
//             await Shop.findOneAndUpdate(filter,update, {new:true,upsert:true})
//             .then(
//               (value) => {
//                 //Send Updated Info to user
//                 res.json({
//                   "jwt": value.jwt,
//                   "username": value.username,
//                   "email": value.email,
//                 });
//                 //console.log(value)
//               }
//             )
//             .catch(err => {
//               res
//                 .status(205)
//                 .send({ message: err });
//             }
//             );
//           }

//         }
//         else res.status(201).send({
//           message: "User not Found!!"
//         });
//     })
//     .catch(err => {
//       res
//         .status(205)
//         .send({ message:err });
//     });
//   };

exports.login = async function (req, res) {
  // Validate request
  if (!req.body.email || !req.body.password) {
    res.status(209).send({ message: "Fields can not be empty!" });
    return;
  }

  await Shop.findOne({ email: req.body.email })
    .then((data) => {
      if (data) {
        bcrypt.compare(
          req.body.password,
          data.password,
          async function (err, isPassMatched) {
            if (isPassMatched === true) {
              try {
                const result = jwt.verify(data.jwt, data.key); //decoded if Valid
                if (result.email == data.email) {
                  res.status(200).json({
                    jwt: data.jwt,
                  });
                }
              } catch (error) {
                //If Token Expired
                const payload = {
                  email: data.email,
                };
                const KEY = uuidv4();
                const token = jwt.sign(payload, KEY, {
                  algorithm: "HS256",
                  expiresIn: "10d",
                });
                //Save Secret KEY to the user database
                const filter = { email: req.body.email };
                const update = { key: KEY, jwt: token };
                await Shop.findOneAndUpdate(filter, update, {
                  new: true,
                  upsert: true,
                })
                  .then((value) => {
                    //Send Updated Info to user
                    res.status(200).json({
                      jwt: value.jwt,
                      // username: value.username,
                      // email: value.email,
                    });
                  })
                  .catch((err) => {
                    res.status(205).send({ message: err.message });
                  });
              }
            } else {
              res.status(209).send({
                message: "Password Incorrect",
              });
            }
          }
        );
      } else {
        //console.log("User Not Found, Login Failed");
        res.status(201).send({
          message: "User not Found!!",
        });
      }
    })
    .catch((err) => {
      //console.log("Database Searching Error Found!!, Login Failed");
      res.status(205).send({
        message: err.message,
      });
    });
};

//get userinfo for first login or app opening
exports.getUserInfo = async function (req, res) {
  if (res.checkresult == 1) {
    await Shop.findOne({ email: res.email })
      .select("username shopname email jwt deliverystation country")
      .populate("country", "countryname")
      .populate("deliverystation", "stationname")
      .then(async (data) => {
        if (data) {
          res.status(200).send(data);
        } else
          res.status(201).send({
            message: "User not Found!!",
          });
      })
      .catch((err) => {
        res.status(205).send({ message: err });
      });
  } else {
    if (res.checkresult == 2) {
      res.status(203).send({
        message: "token Expired!!, Login again",
      });
      //console.log(res.statusCode);
    } else {
      res.status(201).send({
        message: "User Not Found",
      });
    }
  }
};

// Check Email Address and Send OTP to the client Server
exports.checkEmailSendOTP = (req, res) => {
  // Validate request
  if (!req.body.email) {
    res.status(202).send({ message: "Fields can not be empty!" });
    return;
  }
  Shop.findOne({ email: req.body.email })
    .then((data) => {
      if (data) {
        const OTP = otpGenerator.generate(4, {
          lowerCaseAlphabets: false,
          upperCaseAlphabets: false,
          specialChars: false,
        });
        const filter = { email: req.body.email };
        const update = { otp: OTP };
        OtpTable.findOneAndUpdate(filter, update, { new: true, upsert: true })
          .then((value) => {
            res.send(value);
          })
          .catch((err) => {
            res.status(205).send({ message: err });
          });
      } else
        res.status(201).send({
          message: "User not Found!!",
        });
    })
    .catch((err) => {
      res.status(205).send({ message: err });
    });
};

// OTP Verification Codes
exports.otpverification = (req, res) => {
  // Validate request
  if (!req.body.otp) {
    res.status(202).send({ message: "OTP Fields can not be empty!" });
    return;
  }
  // Check Existance of Email address
  OtpTable.findOne({ email: req.body.email })
    .then((data) => {
      if (data) {
        const clientOtp = req.body.otp;
        const serverOtp = data.otp;
        if (clientOtp == serverOtp) {
          res.status(200).send({ message: "OTP Successfully matched :) " });
        } else {
          res.status(206).send({ message: "OTP Does not matche" });
        }
      } else
        res.status(201).send({
          message: "User not Found!!",
        });
    })
    .catch((err) => {
      res.status(205).send({ message: err });
    });
};

// Password Update Codes
exports.updatepass = (req, res) => {
  // Validate request
  if (!req.body.password) {
    res.status(202).send({ message: "Password must not be empty" });
    return;
  }
  // Check Existance of Email address

  const filter = { email: req.body.email };
  const update = { password: req.body.password };

  Shop.findOneAndUpdate(filter, update, { new: true })
    .then((data) => {
      if (data) {
        const payload = {
          username: data.username,
        };

        const KEY = uuidv4();
        const token = jwt.sign(payload, KEY, {
          algorithm: "HS256",
          expiresIn: "10d",
        });
        // send User Info:
        res.json({
          jwt: token,
          username: data.username,
          email: data.email,
        });
      } else
        res.status(201).send({
          message: "Password Update Failded",
        });
    })
    .catch((err) => {
      res.status(205).send({ message: err });
    });
};

//Update Profile Information
// exports.updateProfileInfo = (req, res) => {
//   //console.log(req.file);
//   //console.log(__dirname);
//   //console.log("Received file" + req.file.originalname);
//   res.status(200).send(
//     {message : "success"}
//   );
// }

// ! ||--------------------------------------------------------------------------------||
// ! ||                           Update Profile Information                           ||
// ! ||--------------------------------------------------------------------------------||

exports.updateProfileInfo = async function (req, res) {
  // //console.log(`UpdageProfileInfo : filename is ${req.file.filename} `);
  //console.log(req.body.email);
  const filter = { userid: req.body.userid };

  const update = {
    firstname: req.body.firstname,
    lastname: req.body.lastname,
    address: req.body.address,
    aboutme: req.body.aboutme,
    mobile: req.body.mobile,
    dateofbirth: req.body.dateofbirth,
    facebook: req.body.facebook,
    twitter: req.body.twitter,
    whatsapp: req.body.whatsapp,
  };

  await Shop.findOneAndUpdate(filter, update, { new: true })
    .select(
      "firstname lastname address aboutme mobile dateofbirth facebook twitter whatsapp"
    )
    .then((data) => {
      //console.log(`UpdateProfileInfo : Update Success : ${data}`);
      if (data) {
        res.status(200).send(data);
      } else {
        (err) => {
          res.status(202).send({
            message: "User Not Found",
            reason: err,
          });
        };
      }
    })
    .catch((err) => {
      //console.log("updateProfileInfo : Update failed");
      res.status(205).send({
        message: "Update Failed",
        reason: err,
      });
    });
};
// ! ||--------------------------------------------------------------------------------||
// ! ||                           Update Background Image Url                           ||
// ! ||--------------------------------------------------------------------------------||

exports.updatebgurl = async function (req, res) {
  //console.log("updateBackgroundImageUrl : Update Background Image Url Function is Called");
  //console.log(req.body.userid);
  const filter = { _id: req.body.userid };

  const update = {
    bgimageurl: req.file.filename,
  };

  await Shop.findOneAndUpdate(filter, update, { new: true })
    .then((data) => {
      if (data.bgimageurl.length > 5) {
        //console.log("Background Image uploaded successfully");
        res.status(200).send({
          message: "Background image updated successfully",
        });
      } else {
        res.status(202).send({
          message: "User Not Found",
        });
      }
    })
    .catch((err) => {
      res.status(205).send({
        message: "Update Failed",
        reason: err,
      });
    });
};

// ! ||--------------------------------------------------------------------------------||
// ! ||                           Update Profile Image Url                             ||
// ! ||--------------------------------------------------------------------------------||

// exports.testupload = async function (req, res) {
//   //console.log("Update Profile Image Url Function is Called");
//   const myfilter = { _id: req.body.userid };
//   //console.log(`TestUpload: UserId is : ${req.body.userid}`);

//   const update = {
//     imageurl: req.file.filename,
//   };
//   //console.log(myfilter);

//   await Shop.findOneAndUpdate(myfilter, update, { new: true })
//     .then((data) => {
//       //console.log(`Updated userid is : ${data._id}`);
//       if (data.imageurl.length > 5) {
//         //console.log("Image database updated successfully");
//         //console.log(data.imageurl);
//         res.status(200).send({
//           message: "image database updated successfully",
//         });
//       } else {
//         //console.log("Image database uploade failed");
//         res.status(204).send({
//           message: "User Not Found",
//         });
//       }
//     })
//     .catch((err) => {
//       res.status(205).send({
//         message: "Update Failed",
//         reason: err,
//       });
//     });
// };

/* ------------------------ Upload Profile Image Url ------------------------ */

exports.upProfileImage = async function (req, res) {
  //console.log("Update Profile Image Url Function is Called");
  const filter = { _id: req.body.userid };

  const update = {
    imageurl: req.file.filename,
  };

  await Shop.findOneAndUpdate(filter, update, { new: true })
    .then((data) => {
      if (data) {
        res.status(200).send({
          message: "image updated successfully",
        });
      } else {
        res.status(204).send({
          message: "User Not Found",
        });
      }
    })
    .catch((err) => {
      res.status(205).send({
        message: "Update Failed",
        reason: err,
      });
    });
};

// //Send Image
// exports.serveImage = (req, res) => {
//   const filePath = `${path.join(__dirname, "../../images")}/${
//     req.params.fileName
//   }`;
//   // //console.log(req['authorization']);
//   // //console.log('Image request');
//   // res.sendFile(
//   //   path.resolve(`${path.join(__dirname, '../../images')}/${req.params.fileName}`)
//   // );

//   if (fs.existsSync(filePath)) {
//     ////console.log('File Exist');
//     res.status(200).sendFile(path.resolve(filePath));
//   } else {
//     //console.log("File Does not Exist!!");
//     res.status(205).send({
//       message: "file not Exist",
//     });
//   }
// };

// ! ||--------------------------------------------------------------------------------||
// ! ||                          Get Background Image Controller                          ||
// ! ||--------------------------------------------------------------------------------||

//Send Profile and Content Image
exports.serveBackgroundImage = async function (req, res) {
  //Find Imge url
  const userid = req.params.userid;
  //console.log(`serveBackgroundImage : userid is : ${userid}`);
  await Shop.findOne({ _id: userid })
    .then(async function (data) {
      if (data) {
        //console.log(`serveBackgroundImage : bgimageurl : ${data.bgimageurl}`);
        const fileName = data.bgimageurl;
        const filePath = `${path.join(__dirname, "../../images")}/${fileName}`;

        if (fileName.length > 5) {
          if (fs.existsSync(filePath)) {
            //console.log("File Exist at server and Database");
            res.status(200).sendFile(path.resolve(filePath));
          } else {
            //File not found in folder
            //console.log("serveBackgroundImage : File not found in folder, but found in database");
            res.status(202).send({
              message: "file not Exist in folder",
            });
          }
        } else {
          //if Image not found at database
          //console.log("Image File Not Found in Database!!");
          res.status(202).send({
            message: "file not found in database",
          });
        }
      } else {
        res.status(202).send({
          message: "User not Found!!",
        });
      }
    })
    .catch((err) => {
      //console.log("Image searching error at database");
      res.status(205).send({
        message: err,
      });
    });
};
// ! ||--------------------------------------------------------------------------------||
// ! ||                          Get Profile Image Controller                          ||
// ! ||--------------------------------------------------------------------------------||

//Send Profile and Content Image
exports.serveImage = async function (req, res) {
  //Find Imge url
  const userid = req.params.userid;
  await Shop.findOne({ _id: userid })
    .then(async (data) => {
      if (data) {
        const fileName = data.imageurl;
        const filePath = `${path.join(__dirname, "../../images")}/${fileName}`;

        if (fileName.length > 5) {
          if (fs.existsSync(filePath)) {
            //console.log("File Exist at server and Database");
            res.status(200).sendFile(path.resolve(filePath));
          } else {
            //File not found in folder
            //console.log("serveImage : File not found in folder, but found in database");
            res.status(202).send({
              message: "file not Exist in folder",
            });
          }
        } else {
          //if Image not found at database
          //console.log("Image File Not Found in Database!!");
          res.status(202).send({
            message: "file not found in database",
          });
        }
      } else {
        res.status(202).send({
          message: "User not Found!!",
        });
      }
    })
    .catch((err) => {
      //console.log("Image searching error at database");
      res.status(205).send({
        message: err,
      });
    });
};

// ! ||--------------------------------------------------------------------------------||
// ! ||                           Get User Info Function                               ||
// ! ||--------------------------------------------------------------------------------||

//Update Seletcted Train ID
exports.updatejourney = async function (req, res) {
  //console.log(req.body);
  const filter = { _id: req.body.userid };

  const update = {
    trainid: req.body.trainid,
    tostation: req.body.toStationId,
    fromstation: req.body.fromStationId,
  };

  if (res.checkresult == 1) {
    await Shop.findOneAndUpdate(filter, update, { new: true })
      .select("trainid tostation fromstation")
      .populate("trainid", "trainname")
      .populate("tostation", "stationname")
      .populate("fromstation", "stationname")
      .then((data) => {
        //console.log(`updateJourney : Update Success : ${data}`);
        if (data) {
          res.status(200).send(data);
        } else {
          (err) => {
            res.status(201).send({
              message: "User Not Found",
              reason: err.message,
            });
          };
        }
      })
      .catch((err) => {
        //console.log("updateProfileInfo : Update failed");
        res.status(204).send({
          message: "Update Failed",
          reason: err,
        });
      });
  } else {
    if (res.checkresult == 2) {
      res.status(203).send({
        message: "token Expired!!, Login again",
      });
    } else {
      res.status(202).send({
        message: "User Not Found",
      });
    }
  }
};

//Get All Countries
exports.getallcountry = async (req, res) => {
  console.log("getallcountry: request received ");
  await country
    .find({})
    .then((data) => {
      res.status(200).send(data);
      console.log(data);
    })
    .catch((err) => {
      res.status(205).send({ message: err });
    });
};

//Get station by Country ID For Dropdown List
exports.getstationbycountryid = async (req, res) => {
  const params = req.params[0].split("/");
  console.log(params);
  if (res.checkresult == 1) {
    // const filter = {
    //   countryid: req.params.countryid,
    // };
    const searchquery = () => {
      const searchvalue = params[1];
      if (searchvalue) {
        return {
          countryid: params[0],
          stationname: { $regex: searchvalue, $options: "i" },
        };
      } else {
        return {
          countryid: params[0],
        };
      }
    };
    //query and send data
    await stationModel
      .find(searchquery())
      .then((data) => {
        if (data) {
          //console.log(data);
          res.status(200).send(data);
        } else {
          res.status(209).end();
        }
      })
      .catch((err) => {
        res.status(204).send({ message: err });
      });
  } else {
    if (res.checkresult == 2) {
      res.status(203).send({
        message: "token Expired!!, Login again",
      });
    } else {
      res.status(202).send({
        message: "User Not Found",
      });
    }
  }
};
