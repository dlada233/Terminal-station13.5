import { Antagonist, Category } from '../base';
import { HERETIC_MECHANICAL_DESCRIPTION } from './heretic';

const HereticSmuggler: Antagonist = {
  key: 'hereticsmuggler',
  name: '偷渡异教徒',
  description: ['能在游戏中途产生的异教徒.', HERETIC_MECHANICAL_DESCRIPTION],
  category: Category.Latejoin,
};

export default HereticSmuggler;
