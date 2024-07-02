import { CheckboxInput, FeatureToggle } from '../base';

export const typingIndicator: FeatureToggle = {
  name: '为自己启用输入提示气泡',
  category: 'GAMEPLAY',
  description: '启用表明你在说话的提示气泡.',
  component: CheckboxInput,
};
