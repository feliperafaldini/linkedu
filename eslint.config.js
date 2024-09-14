/** @type {import('eslint').Linter.FlatConfig} */
const config = [
    {
        languageOptions: {
            parserOptions: {
                ecmaVersion: 2018,
            },
            globals: {
                // Defina variáveis globais aqui, se necessário
            },
        },
        rules: {
            "no-restricted-globals": ["error", "name", "length"],
            "prefer-arrow-callback": "error",
            "quotes": ["error", "double", { "allowTemplateLiterals": true }],
        },
        files: ["**/*.js", "**/*.mjs", "**/*.cjs"], // Inclua extensões de arquivo conforme necessário
    },
    {
        languageOptions: {
            env: {
                mocha: true,
            },
        },
        rules: {},
        files: ["**/*.spec.*"],
    },
];

module.exports = config;
