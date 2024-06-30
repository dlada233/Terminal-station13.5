// THIS IS A SKYRAT UI FILE
import { CheckboxInput, FeatureToggle } from '../../base';

export const ticket_ping_pref: FeatureToggle = {
  name: 'Ticket响应',
  category: 'ADMIN',
  description: '启用时将允许你收到未处理的管理员的响应.',
  component: CheckboxInput,
};
