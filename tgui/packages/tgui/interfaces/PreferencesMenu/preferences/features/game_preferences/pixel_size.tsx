import { createDropdownInput, Feature } from '../base';

export const pixel_size: Feature<number> = {
  name: '像素缩放',
  category: 'UI',
  component: createDropdownInput({
    0: '适配',
    1: '适配像素 1x',
    1.5: '适配像素 1.5x',
    2: '适配像素 2x',
    3: '适配像素 3x',
    4: '适配像素 4x',
    4.5: '适配像素 4.5x',
    5: '适配像素 5x',
  }),
};
