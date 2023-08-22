import type { Config } from 'jest';

import defaultConfig from '../../jest.base.config';

const config: Config = {
  ...defaultConfig,
  coverageThreshold: {
    global: {
      statements: 97.8,
      branches: 95.2,
      functions: 97.3,
      lines: 98.1,
    },
  },
};

export default config;
