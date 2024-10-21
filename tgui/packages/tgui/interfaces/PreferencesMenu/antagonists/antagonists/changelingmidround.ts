import { Antagonist, Category } from '../base';
import { CHANGELING_MECHANICAL_DESCRIPTION } from './changeling';

const ChangelingMidround: Antagonist = {
  key: 'changelingmidround',
  name: '太空化形',
  description: [
    `
    在一轮游戏中期出现的化形不会直接潜伏在船员之中，而是会从太空抵达，这比普通化形
    开局要困难一些!
    `,
    CHANGELING_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Midround,
};

export default ChangelingMidround;
