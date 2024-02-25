import { LabeledList, Section } from '../../components';

export const GeneticMakeupInfo = (props) => {
  const { makeup } = props;

  return (
    <Section title="Enzyme Information">
      <LabeledList>
        <LabeledList.Item label="名称">
          {makeup.name || 'None'}
        </LabeledList.Item>
        <LabeledList.Item label="血型">
          {makeup.blood_type || 'None'}
        </LabeledList.Item>
        <LabeledList.Item label="Unique Enzyme">
          {makeup.UE || 'None'}
        </LabeledList.Item>
        <LabeledList.Item label="Unique Identifier">
          {makeup.UI || 'None'}
        </LabeledList.Item>
        <LabeledList.Item label="Unique Features">
          {makeup.UF || 'None'}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
