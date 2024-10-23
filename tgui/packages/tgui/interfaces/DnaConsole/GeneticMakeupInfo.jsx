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
        <LabeledList.Item label="唯一DNA酶">
          {makeup.UE || 'None'}
        </LabeledList.Item>
        <LabeledList.Item label="唯一识别码">
          {makeup.UI || 'None'}
        </LabeledList.Item>
        <LabeledList.Item label="唯一特征码">
          {makeup.UF || 'None'}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
