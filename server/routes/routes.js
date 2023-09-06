const authControllers = require("../controllers/auth/auth_controller");
const productController = require("../controllers/product/product_controller");
const middlewears = require("../controllers/middlewears.js");

module.exports = (app) => {
  // ! ||--------------------------------------------------------------------------------||
  // ! ||                              Authentication Routes                             ||
  // ! ||--------------------------------------------------------------------------------||
  //Authentication routes
  app.get("/getUserInfo", middlewears.checkuser, authControllers.getUserInfo);
  app.post("/createshop", authControllers.createshop);
  app.post("/login", authControllers.login);

  app.post("/account", authControllers.checkEmailSendOTP);
  app.post("/otpverification", authControllers.otpverification);
  app.post("/updatepass", authControllers.updatepass);
  app.post("/updateProfileInfo", authControllers.updateProfileInfo);
  app.get("/getallcountry", authControllers.getallcountry);
  app.get(
    "/getStationByCountry/*",
    middlewears.checkuser,
    authControllers.getstationbycountryid
  );
  //Upload Background Image
  //app.post("/upbgimage", middlewears.savebg, authControllers.updatebgurl); //middlewere helping article : https://reflectoring.io/express-middleware/

  app.post(
    "/uploadSingleImage",
    middlewears.upProfileImage,
    authControllers.upProfileImage
  );

  app.get("/getimage/:userid", authControllers.serveImage);
  app.get("/backgroundImage/:userid", authControllers.serveBackgroundImage);
  //app.use('/getimage/:fileName', express.static('images'), authControllers.serveImage);

  // ! ||--------------------------------------------------------------------------------||
  // ! ||                                  Product Routes                                 ||
  // ! ||--------------------------------------------------------------------------------||
  app.post("/addproduct", middlewears.checkuser, productController.addproduct);
  app.post(
    "/uploadproductimage",
    middlewears.saveshopimage,
    productController.updateproducturl
  );
  app.get(
    "/getproducts/*",
    middlewears.checkuser,
    productController.getproducts
  );
  app.get(
    "/getsingleproduct/:productid",
    middlewears.checkuser,
    productController.getsingleproduct
  );
  app.get("/getproductimage/:productid", productController.getproductimage);
  app.post(
    "/deleteproduct/:productid",
    middlewears.checkuser,
    productController.deleteProduct
  );
  app.post(
    "/updateProductDeleteImage",
    middlewears.checkuser,
    productController.updateProductDeleteImage
  );
  app.post(
    "/updateProductChangeImage",
    middlewears.saveshopimage,
    productController.updateProductChangeImage
  );
  app.post(
    "/updateOnlyProductInformation",
    middlewears.checkuser,
    productController.updateOnlyProductInformation
  );
};
