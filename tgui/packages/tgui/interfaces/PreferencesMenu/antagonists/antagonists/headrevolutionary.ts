import { Antagonist, Category } from '../base';

export const REVOLUTIONARY_MECHANICAL_DESCRIPTION = `
      使用特殊闪光灯，让尽可能多的人加入革命事业，杀死或流放空间所有的部长级人物.
   `;

const HeadRevolutionary: Antagonist = {
  key: 'headrevolutionary',
  name: '革命领袖',
  description: ['VIVA LA REVOLUTION!', REVOLUTIONARY_MECHANICAL_DESCRIPTION],
  category: Category.Roundstart,
};

export default HeadRevolutionary;
