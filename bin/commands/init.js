#!/usr/bin/env node
// vim: set ft=javascript:

const { initialize } = require('../../lib/config');
const { initSpace } = require('../../lib/store');

exports.command = 'init';

exports.desc =
  'Prepares the specified space to allow managed migration scripts.\nThe "Migration" content-type will be created in your contentful space';

exports.builder = (yargs) => {
  yargs
    .option('access-token', {
      alias: 't',
      describe:
        'Contentful Management API access token',
      demandOption: true,
      default: process.env.CONTENTFUL_MANAGEMENT_ACCESS_TOKEN,
      defaultDescription: 'environment var CONTENTFUL_MANAGEMENT_ACCESS_TOKEN'
    })
    .option('space-id', {
      alias: 's',
      describe: 'space id to use',
      type: 'string',
      requiresArg: true,
      demandOption: true
    })
    .option('environment-id', {
      alias: 'e',
      describe: 'id of the environment within the space',
      type: 'string',
      requiresArg: true,
      default: 'master'
    })
    .option('multiple-folders', {
      describe: 'allows managing group of migrations in multiple folders',
      type: 'boolean',
      default: false
    })
  ;
};

exports.handler = async ({ accessToken, spaceId, environmentId, multipleFolders}) => {
  await initSpace(accessToken, spaceId, environmentId);
  return initialize(!multipleFolders);
};
