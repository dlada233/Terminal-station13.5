import { exhaustiveCheck } from 'common/exhaustive';

import { Dropdown } from '../../components';
import { RandomSetting } from './data';

const options = [
  {
    displayText: '不要随机化',
    value: RandomSetting.Disabled,
  },

  {
    displayText: '总是随机化',
    value: RandomSetting.Enabled,
  },

  {
    displayText: '扮演反派时随机化',
    value: RandomSetting.AntagOnly,
  },
];

export const RandomizationButton = (props: {
  dropdownProps?: Record<string, unknown>;
  setValue: (newValue: RandomSetting) => void;
  value: RandomSetting;
}) => {
  const { dropdownProps = {}, setValue, value } = props;

  let color;

  switch (value) {
    case RandomSetting.AntagOnly:
      color = 'orange';
      break;
    case RandomSetting.Disabled:
      color = 'red';
      break;
    case RandomSetting.Enabled:
      color = 'green';
      break;
    default:
      exhaustiveCheck(value);
  }

  return (
    <Dropdown
      color={color}
      {...dropdownProps}
      clipSelectedText={false}
      icon="dice-d20"
      options={options}
      noChevron
      onSelected={setValue}
      menuWidth="120px"
      width={1.85}
      selected="None"
    />
  );
};
