import type { Config } from 'jest';

import defaultConfig from '../../jest.base.config';

const config: Config = {
  ...defaultConfig,
  coverageThreshold: {
    global: {
      statements: 97.83,
      branches: 95.75,
      functions: 97.4,
      lines: 98.15,
    },
  },
};

export default config;
