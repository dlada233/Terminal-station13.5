import { Antagonist, Category } from '../base';

const SentientCreature: Antagonist = {
  key: 'sentiencepotionspawn',
  name: '感知动物',
  description: [
    `
		要么是宇宙间的偶然，要么是船员们的恶作剧，你被赋予了感知!
	  `,

    `
		善恶上下限较为宽泛的扮演角色，较为温和的有随机事件、感知药水产生的普通高智商动物，
    不太友好的有鼠王和强化的拉瓦兰生物.
	  `,
  ],
  category: Category.Midround,
};

export default SentientCreature;
