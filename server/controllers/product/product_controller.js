const productModel = require("../../models/product_model");
const path = require("path");
const fs = require("fs");

// ! ||--------------------------------------------------------------------------------||
// ! ||                           Upload Product Image Url                           ||
// ! ||--------------------------------------------------------------------------------||

exports.updateproducturl = async function (req, res) {
  ////console.log("updateBackgroundImageUrl : Update Background Image Url Function is Called");
  ////console.log(req.body.userid);
  const filter = { _id: req.body.productid };

  const update = {
    imageurl: req.file.filename,
  };

  await productModel
    .findOneAndUpdate(filter, update, { new: true })
    .then((data) => {
      if (data.imageurl.length > 5) {
        ////console.log("Product Image uploaded successfully");
        res.status(200).send({
          message: "Background image updated successfully",
        });
      } else {
        res.status(201).send({
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

//Add New productModel
exports.addproduct = (req, res) => {
  //console.log(req.body);
  const Data = new productModel({
    name: req.body.productName,
    description: req.body.productDescription,
    price: req.body.productPrice,
    stock: req.body.productStock,
    category: req.body.productCategory,
    shopid: req.body.shopid,
    imageurl: "",
  });
  if (res.checkresult == 1) {
    Data.save()
      .then((data) => {
        //Send data to the user
        if (data) {
          //console.log(data);
          res.status(200).send(data);
        } else {
          res.status(201).end();
        }
      })
      .catch((err) => {
        res.status(205).send({
          message:
            err.message ||
            "Some error occurred while creating the productModel.",
        });
      });
  } else {
    if (res.checkresult == 2) {
      res.status(203).send({
        message: "token Expired!!, Login again",
      });
      ////console.log(res.statusCode);
    } else {
      res.status(209).send({
        message: "User Not Found",
      });
    }
  }
};

//Get All Product from Database
exports.getproducts = async (req, res) => {
  const params = req.params[0].split("/");
  const shopId = params[0];
  ////console.log(params);
  // const balance = parseInt(params[1]); //convert to number
  // const demand = parseInt(params[2]); //convert to number
  if (res.checkresult == 1) {
    await productModel
      .find({ shopid: shopId })
      .then((data) => {
        if (data.length > 0) {
          //check if the status is at the end of the list.
          // const totalItems = data.length;
          // const suppliedItems = balance + demand;
          // const isItemAtEnd = totalItems <= suppliedItems;
          // res.header("Access-Control-Expose-Headers", "isItemEnd"); // allow 'replyend' to expose headers in flutter web
          // res.append("isItemEnd", isItemAtEnd);
          // const newdata = data.slice(
          //   balance,
          //   suppliedItems >= totalItems ? totalItems : suppliedItems
          // );
          // res.status(200).send(newdata);
          res.status(200).send(data);
          ////console.log(data);
        } else {
          res.status(201).send({
            message: "No lives Found!!",
          });
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
      ////console.log(res.statusCode);
    } else {
      res.status(202).send({
        message: "User Not Found",
      });
    }
  }
};

//Get Single Product from Database
exports.getsingleproduct = async (req, res) => {
  const productid = req.params.productid;
  ////console.log(params);
  if (res.checkresult == 1) {
    await productModel
      .findOne({ _id: productid })
      .then((data) => {
        if (data) {
          res.status(200).send(data);
          //console.log(data);
        } else {
          res.status(201).send({
            message: "No lives Found!!",
          });
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
      ////console.log(res.statusCode);
    } else {
      res.status(202).send({
        message: "User Not Found",
      });
    }
  }
};

// ! ||--------------------------------------------------------------------------------||
// ! ||                          Get Profile Image Controller                          ||
// ! ||--------------------------------------------------------------------------------||

//Send Profile and Content Image
exports.getproductimage = async function (req, res) {
  //Find Imge url
  const productid = req.params.productid;
  ////console.log(`Product id : ${productid}`);
  await productModel
    .findOne({ _id: productid })
    .then(async (data) => {
      if (data) {
        const fileName = data.imageurl;

        const filePath = `${path.join(
          __dirname,
          "../../images/products"
        )}/${fileName}`;
        // const filePath = previousFilePath.split("\\").join("/");
        // //console.log(`New path is : ${path.resolve(filePath)}`);

        if (fileName.length > 5) {
          ////console.log(filePath);
          if (fs.existsSync(filePath)) {
            ////console.log("File Exist at server and Database");
            res.status(200).sendFile(path.resolve(filePath));
          } else {
            //File not found in folder
            ////console.log("serveImage : File not found in folder, but found in database");
            res.status(201).send({
              message: "file not Exist in folder",
            });
          }
        } else {
          //if Image not found at database
          ////console.log("Image File Not Found in Database!!");
          res.status(201).send({
            message: "file not found in database",
          });
        }
      } else {
        res.status(201).send({
          message: "User not Found!!",
        });
      }
    })
    .catch((err) => {
      ////console.log("Image searching error at database");
      res.status(205).send({
        message: err,
      });
    });
};

//Delete Single product
exports.deleteProduct = async (req, res) => {
  //Delete Product
  const deleteProductInfo = async (req, res) => {
    //console.log("Product Info is Deleting");
    const filter = {
      _id: req.params.productid,
    };
    await productModel
      .findOneAndRemove(filter, { new: true })
      .then((data) => {
        if (data) {
          res.status(200).send({
            message: "Product Deleted Successfully",
          });
        } else {
          res.status(209).send({ message: "Deletion Failed!!" });
        }
      })
      .catch((err) => {
        res.status(209).send({ message: err.message });
      });
  };

  let fileName;
  //serch for filename
  const filter = {
    _id: req.params.productid,
  };
  await productModel
    .findOne(filter)
    .then((data) => {
      if (data) {
        fileName = data.imageurl;
        const previousFilePath = `${path.join(
          __dirname,
          "../../images/products"
        )}/${fileName}`;
        const newPath = previousFilePath.split("\\").join("/");
        if (fileName.length > 5) {
          //console.log("Image fileName found in database");
          //console.log(newPath);
          if (fs.existsSync(newPath)) {
            //console.log("Previous Image File Exist");
            fs.rm(newPath, { force: true }, (err) => {
              if (err) {
                res.status(205).send({
                  message: err.message,
                });
                //console.log(err);
              } else {
                deleteProductInfo(req, res).then((value) => {
                  //console.log("Product Image Removed");
                });
                // res.status(200).send({
                //   message: "Image removed successfully",
                // });
              }
            });
            //return cb(null, true);
          } else {
            deleteProductInfo(req, res);
            ////console.log("Filename found is Database but File not found in Folder");
            // res.status(200).send({
            //   message: "No previous image found",
            // });
          }
        } else {
          deleteProductInfo(req, res);
          ////console.log("Image fileName not found in database");
          // res.status(200).send({
          //   message: "No image found in database",
          // });
        }
        return;
      }
      ////console.log("User not found");
      res.status(201).send({
        message: "no product found",
      });
    })
    .catch((err) => {
      ////console.log(err);
      res.status(205).send({
        message: "Something went wrong when product searching",
      });
    });
};

//Update Product Info & Delete Product image
exports.updateProductDeleteImage = async (req, res) => {
  const updateProductInfo = async (req, res) => {
    if (res.checkresult == 1) {
      ////console.log("Product is Updating...");
      ////console.log(req.body);
      const filter = {
        _id: req.body.productid,
      };
      const update = {
        name: req.body.productName,
        description: req.body.productDescription,
        price: req.body.productPrice,
        stock: req.body.productStock,
        category: req.body.productCategory,
        imageurl: "",
      };

      productModel
        .findOneAndUpdate(filter, update, { new: true }) //new will return true updated product info
        .then((data) => {
          if (data) {
            res.status(200).send({
              message: "Product Updated Successfully",
            });
          } else {
            res.status(209).send({ message: "Update Failed!!" });
          }
        })
        .catch((err) => {
          res.status(209).send({ message: err.message });
        });
    } else {
      if (res.checkresult == 2) {
        res.status(203).send({
          message: "token Expired!!, Login again",
        });
      } else {
        res.status(201).send({
          message: "User Not Found",
        });
      }
    }
  };
  let fileName;
  //serch for filename
  const filter = {
    _id: req.body.productid,
  };
  await productModel
    .findOne(filter)
    .then((data) => {
      if (data) {
        fileName = data.imageurl;
        const previousFilePath = `${path.join(
          __dirname,
          "../../images/products"
        )}/${fileName}`;
        const newPath = previousFilePath.split("\\").join("/");
        if (fileName.length > 5) {
          //console.log("Image fileName found in database");
          //console.log(newPath);
          if (fs.existsSync(newPath)) {
            //console.log("Previous Image File Exist");
            fs.rm(newPath, { force: true }, (err) => {
              if (err) {
                res.status(205).send({
                  message: err.message,
                });
                //console.log(err);
              } else {
                updateProductInfo(req, res).then((value) => {
                  console.log("Product Image Removed and Product Info Updated");
                });
              }
            });
          } else {
            updateProductInfo(req, res);
          }
        } else {
          updateProductInfo(req, res);
        }
        return;
      }
      ////console.log("User not found");
      res.status(201).send({
        message: "no product found",
      });
    })
    .catch((err) => {
      ////console.log(err);
      res.status(205).send({
        message: "Something went wrong when product searching",
      });
    });
};

//Update Product Info & Change Product image
exports.updateProductChangeImage = async (req, res) => {
  const filter = { _id: req.body.productid };

  const update = {
    name: req.body.productName,
    description: req.body.productDescription,
    price: req.body.productPrice,
    stock: req.body.productStock,
    category: req.body.productCategory,
    imageurl: req.file.filename,
  };

  await productModel
    .findOneAndUpdate(filter, update, { new: true })
    .then((data) => {
      if (data.imageurl == req.file.filename) {
        console.log("Product Info & Image Updated successfully");
        res.status(200).send({
          message: "Product Info & Image Updated successfully",
        });
      } else {
        res.status(201).send({
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

//Update Only Product information
exports.updateOnlyProductInformation = async (req, res) => {
  if (res.checkresult == 1) {
    ////console.log("Product is Updating...");
    ////console.log(req.body);
    const filter = {
      _id: req.body.productid,
    };
    const update = {
      name: req.body.productName,
      description: req.body.productDescription,
      price: req.body.productPrice,
      stock: req.body.productStock,
      category: req.body.productCategory,
    };

    productModel
      .findOneAndUpdate(filter, update, { new: true }) //new will return true updated product info
      .then((data) => {
        if (data) {
          res.status(200).send({
            message: "Product Updated Successfully",
          });
        } else {
          res.status(209).send({ message: "Update Failed!!" });
        }
      })
      .catch((err) => {
        res.status(209).send({ message: err.message });
      });
  } else {
    if (res.checkresult == 2) {
      res.status(203).send({
        message: "token Expired!!, Login again",
      });
    } else {
      res.status(201).send({
        message: "User Not Found",
      });
    }
  }
};
