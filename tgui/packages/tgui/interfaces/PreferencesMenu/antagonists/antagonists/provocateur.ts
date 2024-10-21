import { Antagonist, Category } from '../base';
import { REVOLUTIONARY_MECHANICAL_DESCRIPTION } from './headrevolutionary';

const Provocateur: Antagonist = {
  key: 'provocateur',
  name: '煽动者',
  description: [
    `
      一种可以在游戏中期加入的革命领袖.
    `,

    REVOLUTIONARY_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Latejoin,
};

export default Provocateur;
