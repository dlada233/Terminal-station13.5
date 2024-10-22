// THIS IS A SKYRAT SECTOR UI FILE
import { Feature, FeatureNumberInput } from '../../base';

export const chrono_age: Feature<number> = {
  name: '年龄 (存在年龄)',
  description:
    '代表自你的角色出生以来在宇宙中实际存在的时间，包括在低温冬眠/局部引力/速度导致的时间膨胀中度过的时间.',
  component: FeatureNumberInput,
};
