local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- Snippet that triggers on "kdeploy"
  s('kdeploy', {
    t {
      'apiVersion: apps/v1',
      'kind: Deployment',
      'metadata:',
      '  name: ',
    },
    i(1, 'my-deployment'),
    t {
      '',
      '  labels:',
      '    app: ',
    },
    i(2, 'my-app'),
    t {
      '',
      'spec:',
      '  replicas: ',
    },
    i(3, '1'),
    t {
      '',
      '  selector:',
      '    matchLabels:',
      '      app: ',
    },
    i(4, 'my-app'),
    t {
      '',
      '  template:',
      '    metadata:',
      '      labels:',
      '        app: ',
    },
    i(5, 'my-app'),
    t {
      '',
      '    spec:',
      '      containers:',
      '      - name: ',
    },
    i(6, 'my-container'),
    t {
      '',
      '        image: ',
    },
    i(7, 'my-image:latest'),
  }),
}
