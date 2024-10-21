import { Antagonist, Category } from '../base';

export const HERETIC_MECHANICAL_DESCRIPTION = `
      寻找空间异响或献祭船员来获得更多的知识，解锁更强大的力量，最终完成你的飞升.
   `;

const Heretic: Antagonist = {
  key: 'heretic',
  name: '异教徒',
  description: [
    `
      遗忘, 吞噬, 掏空. 人类忘记了遥远世界的那座磅礴王座, 此刻漫宿剪去了秘影，
      我要在其中翩然起一曲死亡与恐惧之舞...
    `,
    HERETIC_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default Heretic;
