import { Antagonist, Category } from '../base';
import { TRAITOR_MECHANICAL_DESCRIPTION } from './traitor';

const SyndicateSleeperAgent: Antagonist = {
  key: 'syndicatesleeperagent',
  name: '辛迪加沉睡特工',
  description: [
    `
      一种中局加入的叛徒.
    `,
    TRAITOR_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Midround,
  priority: -1,
};

export default SyndicateSleeperAgent;
