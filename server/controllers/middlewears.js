const multer = require("multer"); //multer package
const { v4: uuidv4 } = require("uuid");
const fs = require("fs");
const path = require("path");
const jwt = require("jsonwebtoken");
const User = require("../models/shop_model");
const shopModel = require("../models/shop_model");
const productModel = require("../models/product_model");

// ! ||--------------------------------------------------------------------------------||
// ! ||                              Save Shop Banner image                             ||
// ! ||--------------------------------------------------------------------------------||
//multer Storage setup
const productimagestorrage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "images/products"); //Just change the folder path to save images
  },

  filename: (req, file, cb) => {
    const imageName = uuidv4();
    const extension = file.originalname.split(".").pop();
    cb(null, `${imageName}.${extension}`);
  },
});

/* ------------------------------- Check File ------------------------------- */
async function verifyfile(req, file, cb) {
  let fileName;
  //serch for filename
  const productid = req.body.productid;
  await productModel
    .findOne({ _id: productid })
    .select("imageurl")
    .then((data) => {
      if (data) {
        fileName = data.imageurl;
        //console.log(`File name from Database is : ${fileName}`);
        //console.log(`FormUpload : New file is : ${file}`);
        //console.log(file);
        const previousFilePath = `${path.join(
          __dirname,
          "../images/products"
        )}/${fileName}`;
        const newPath = previousFilePath.split("\\").join("/");
        console.log(`New path is : ${newPath}`);
        if (fileName.length > 5) {
          //console.log("Image fileName found in database");
          if (fs.existsSync(newPath)) {
            console.log("Previous Image File Exist");
            fs.rm(newPath, { force: true }, (err) => {
              if (err) {
                //console.log(err);
                cb(null, false);
              } else {
                //console.log("Previous Image Removed");
                cb(null, true);
              }
            });
            //return cb(null, true);
          } else {
            //console.log("Filename found is Database but File not found in Folder");
            cb(null, true);
          }
        } else {
          console.log("Older Image not Exists");
          cb(null, true);
        }
      } else {
        //console.log("User not found");
        cb(null, false);
      }
    })
    .catch((err) => {
      //console.log(err);
      cb(null, false);
    });
}

const uploadshopimage = multer({
  storage: productimagestorrage,
  fileFilter: verifyfile,
});

exports.saveshopimage = uploadshopimage.single("image"); //key must be same as client key

// ! ||--------------------------------------------------------------------------------||
// ! ||                           Save Profile Image                          ||
// ! ||--------------------------------------------------------------------------------||

//multer Storage setup
const multerStorageForimage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "images");
  },
  filename: (req, file, cb) => {
    const imageName = uuidv4();
    const extension = file.originalname.split(".").pop();
    cb(null, `${imageName}.${extension}`);
  },
});

/* ------------------------- Check Existance of file ------------------------ */

async function checkimagefile(req, file, cb) {
  let fileName;
  //serch for filename
  const userid = req.body.userid;
  await shopModel
    .findOne({ _id: userid })
    .select("imageurl")
    .then((data) => {
      if (data) {
        fileName = data.imageurl;
        const previousFilePath = `${path.join(
          __dirname,
          "../images"
        )}/${fileName}`;
        const newPath = previousFilePath.split("\\").join("/");
        if (fileName.length > 5) {
          //console.log("Image fileName found in database");
          if (fs.existsSync(newPath)) {
            //console.log("Previous Image File Exist");
            fs.rm(newPath, { force: true }, function (err) {
              if (err) {
                //console.log(err);
                cb(null, false);
              } else {
                //console.log("Previous Image Removed");
                cb(null, true);
              }
            });
            //return cb(null, true);
          } else {
            //console.log("Filename found is Database but File not found in Folder");
            cb(null, true);
          }
        } else {
          //console.log("Image fileName not found in database");
          cb(null, true);
        }
      } else {
        //console.log("User not found");
        cb(null, false);
      }
    })
    .catch((err) => {
      //console.log(err);
      cb(null, false);
    });
}

const profileImage = multer({
  storage: multerStorageForimage,
  fileFilter: checkimagefile,
  //limits: { fileSize: 1000000 }, //max file size in bytes, 1000000 Bytes = 1 MB
});

exports.upProfileImage = profileImage.single("singlepicture");

// ! ||--------------------------------------------------------------------------------||
// ! ||                            User Checking Middlewere                            ||
// ! ||--------------------------------------------------------------------------------||

exports.checkuser = async (req, res, next) => {
  //console.log("I am called in middleware");
  const authtoken = req.headers.authorization;

  //Check the headers
  if (!authtoken) {
    res.status(203).send({ message: "Authorization Failed!" });
    return;
  }

  try {
    const jwttoken = authtoken.slice(7, authtoken.length);
    const tokenEmail = jwt.decode(jwttoken).email;
    await shopModel.findOne({ email: tokenEmail }).then((data) => {
      if (data) {
        const result = jwt.verify(jwttoken, data.key); //decoded if exist
        if (result.email == data.email) {
          res.checkresult = 1;
          res.email = data.email;
        }
        next(); //execute next middleware
        return;
      }
      res.checkresult = 0; //means no user found
      res.status(201).send({
        message: "User not found in Database",
      });
    });
  } catch (error) {
    res.checkresult = 2;
    res.status(203).send({
      message: "Token Expired or Invalid Token",
    });
    //console.log("Token Expired or Invalid Token");
  }
};
