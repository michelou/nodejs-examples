'use strict'

const Bunyan = require('bunyan')

const logger = Bunyan.createLogger({ name: 'example-8' })

logger.info('Hello logging')
