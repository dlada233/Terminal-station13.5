import { Antagonist, Category } from '../base';
import { WIZARD_MECHANICAL_DESCRIPTION } from './wizard';

const WizardMidround: Antagonist = {
  key: 'wizardmidround',
  name: '巫师 (中局)',
  description: [
    '可以在中局加入，由幽灵扮演的巫师.',
    WIZARD_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Midround,
};

export default WizardMidround;
