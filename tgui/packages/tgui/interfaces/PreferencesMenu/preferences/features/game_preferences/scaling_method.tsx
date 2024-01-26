import { createDropdownInput, Feature } from '../base';

export const scaling_method: Feature<string> = {
  name: '缩放方法',
  category: 'UI',
  component: createDropdownInput({
    blur: '双线性',
    distort: '最近邻',
    normal: '点采样',
  }),
};
