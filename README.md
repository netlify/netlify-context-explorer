# Introduction

Netlify Context Explorer adds Deploy Context information to your web project.

Netlify Context Explorer is released under the [MIT License](LICENSE).
Please make sure you understand its [implications and guarantees](https://writing.kemitchell.com/2016/09/21/MIT-License-Line-by-Line.html).

## Usage

This package contains two components:

1. Context Recorder: This webpack plugin reads information from the deploy environment and stores it in a json file in your distribution directory.
2. Context Viewer: This Elm library displays the information from the json file in your site.

This is how it looks on our website:

![](https://cloud.githubusercontent.com/assets/1050/20510491/72b326f0-b025-11e6-9f35-a0be2d8ac2c0.png)

### ContextRecorder:

Add the plugin to your webpack configuration:

```js
var ContextRecorder = require("netlify-context-explorer/ContextRecorder");

export default {
  ...

  plugins: [
    ...
    new ContextRecorder()
  ]
}
```

### ContextViewer:

Create an element in your HTML to load the viewer called `netlify-context` and load the viewer:

```html
<div id="netlify-context"></div>
```

```js
var root = document.getElementById("netlify-context");
if (root) {
  var elm = require("netlify-context-explorer/ContextViewer");
  elm.ContextViewer.App.embed(root);
}
```

The context viewer ships with default styles that you can import into your css:

```css
@import "netlify-context-explorer/ContextViewer";
```

You can also style the bar to integrate better in your site. Just implement the styles like [the defaults we provide](src/css/index.css).

## Configuration

By default, the context explorer is only enabled for Deploy Previews.

Both, the context recorder and viewer let you configure where to put the json file and when to load the viewer.
They can take a map with those options when they are initialized:

```
{
  "jsonUrl": "/js/netlify-context.json",
  "contextsEnabled": ["deploy-preview", "branch-deploy"]
}
```

You can read more about deploy contexts in [Netlify's documentation](https://www.netlify.com/docs/continuous-deployment/#deploy-contexts).

### ContextRecorder

Add the options map to the plugin initialization:

```js
var ContextRecorder = require("netlify-context-explorer/ContextRecorder");
var options = {
  "jsonUrl": "/js/netlify-context.json",
  "contextsEnabled": ["deploy-preview", "branch-deploy"]
};

export default {
  ...

  plugins: [
    ...
    new ContextRecorder(options);
  ]
}
```

### ContextViewer

Add the options map as the second argument to the `embed` call:

```js
var root = document.getElementById("netlify-context");
if (root) {
  var options = {
    "jsonUrl": "/js/netlify-context.json",
    "contextsEnabled": ["deploy-preview", "branch-deploy"]
  };

  var elm = require("netlify-context-explorer/ContextViewer");
  elm.ContextViewer.App.embed(root, options);
}
```
