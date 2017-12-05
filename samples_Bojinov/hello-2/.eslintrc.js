// https://eslint.org/docs/user-guide/configuring

module.exports = {
  root: true,
  env: {
    browser: true,
  },
  // https://github.com/standard/standard/blob/master/docs/RULES-en.md
  extends: 'standard',
  // add your custom rules here
  'rules': {
    // enforce spacing inside braces
    //'object-curly-spacing': ['error', 'always'],
    // enforce spaces inside brackets
    //'array-bracket-spacing': ['error', 'never'],
    'camelcase': 0, /* 0 - turned off, 1 - warnings, 2 - errros */
    'space-before-function-paren': ['error', {
      'anonymous': "always",
      'named': "never",
      'asyncArrow': "always"
    }]
  }
}
