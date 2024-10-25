import { Antagonist, Category } from '../base';

const Fugitive: Antagonist = {
  key: 'fugitive',
  name: '逃亡者',
  description: [
    `
    有众多逃亡出身，但无论哪一种，你都在被追捕. 在追捕你和你朋友的赏金猎人到来前，你
    有十分钟的准备时间!
    `,
  ],
  category: Category.Midround,
};

export default Fugitive;
