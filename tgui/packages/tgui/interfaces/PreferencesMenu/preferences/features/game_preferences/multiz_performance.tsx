import { createDropdownInput, Feature } from '../base';

export const multiz_performance: Feature<number> = {
  name: '跨z轴细节',
  category: 'GAMEPLAY',
  description: '更改跨z轴的细节, 以此来更进性能',
  component: createDropdownInput({
    [-1]: '标准',
    2: '高',
    1: '中',
    0: '低',
  }),
};
