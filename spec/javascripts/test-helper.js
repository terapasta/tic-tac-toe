module.exports = {
  _path(basePath, filePath) {
    let splitDir = __dirname.split("/");
    splitDir.shift();

    let appRootIndex;
    splitDir.map((dir, i) => {
      if (dir === "spec") {
        appRootIndex = i;
      }
    });

    splitDir.splice(appRootIndex, splitDir.length - appRootIndex);
    splitDir = splitDir.concat(basePath.split("/"))
    splitDir = splitDir.concat(filePath.split("/"))

    return "/" + splitDir.join("/");
  },

  appPath(filePath) {
    return this._path("app/assets/javascripts", filePath);
  },

  supportPath(filePath) {
    return this._path("spec/support/javascript", filePath);
  }
};
