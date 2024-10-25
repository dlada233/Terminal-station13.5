import { Antagonist, Category } from '../base';
import { TRAITOR_MECHANICAL_DESCRIPTION } from './traitor';

const SyndicateInfiltrator: Antagonist = {
  key: 'syndicateinfiltrator',
  name: '辛迪加渗透者',
  description: ['一种中局加入的叛徒.', TRAITOR_MECHANICAL_DESCRIPTION],
  category: Category.Latejoin,
  priority: -1,
};

export default SyndicateInfiltrator;
