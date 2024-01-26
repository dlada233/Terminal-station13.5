import { multiline } from 'common/string';

import { Feature, FeatureDropdownInput } from '../base';

export const preferred_map: Feature<string> = {
  name: '偏好地图',
  category: 'GAMEPLAY',
  description: multiline`
    在地图投票时未得出结果时作为参考的数据.
  `,
  component: FeatureDropdownInput,
};
