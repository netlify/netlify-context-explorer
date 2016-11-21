/**
 *
 * @param {object} options:
 * - jsonUrl: path to save the context file within the distribution dir, by default "netlify-context.json".
 * - contextsEnabled: array with context names the recorder is enabled for, by default ["deploy-preview"]
 * @constructor
 */
function ContextRecorder(options) {
  this.options = options || {};
  this.jsonUrl = this.options.jsonUrl || "netlify-context.json";
  this.contextsEnabled = this.options.contextsEnabled || ["deploy-preview"];
}

ContextRecorder.prototype.apply = function(compiler) {
  if (this.contextsEnabled.includes(process.env["CONTEXT"])) {
    var path = this.jsonUrl;
    if (path.startsWith("/")) {
      path = path.replace("/", "");
    }

    compiler.plugin('emit', function(compilation, callback) {
      saveContext(compilation, path);
      callback();
    });
  }
};

function saveContext(compilation, path) {
  var ctx = {
    "context": process.env["CONTEXT"],
    "repository": process.env["REPOSITORY_URL"],
    "headBranch": process.env["HEAD"] || "master",
    "commitRef": process.env["COMMIT_REF"],
    "reviewId": process.env["REVIEW_ID"]
  };

  var jsonCtx = JSON.stringify(ctx);
  compilation.assets[path] = {
    source: function() {
      return jsonCtx;
    },
    size: function() {
      return jsonCtx.length;
    }
  };
}

module.exports = ContextRecorder;
