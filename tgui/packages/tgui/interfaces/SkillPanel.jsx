import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

const skillgreen = {
  color: 'lightgreen',
  fontWeight: 'bold',
};

const skillyellow = {
  color: '#FFDB58',
  fontWeight: 'bold',
};

export const SkillPanel = (props) => {
  const { act, data } = useBackend();
  const skills = data.skills || [];
  return (
    <Window title="管理技能" width={600} height={500}>
      <Window.Content scrollable>
        <Section title={skills.playername}>
          <LabeledList>
            {skills.map((skill) => (
              <LabeledList.Item key={skill.name} label={skill.name}>
                <span style={skillyellow}>{skill.desc}</span>
                <br />
                <Level skill_lvl_num={skill.lvlnum} skill_lvl={skill.lvl} />
                <br />
                总经验值: [{skill.exp} XP]
                <br />
                下一级所需XP:
                {skill.exp_req !== 0 ? (
                  <span>
                    [{skill.exp_prog} / {skill.exp_req}]
                  </span>
                ) : (
                  <span style={skillgreen}>[达到最大]</span>
                )}
                <br />
                整体技能成长: [{skill.exp} / {skill.max_exp}]
                <ProgressBar value={skill.exp_percent} color="good" />
                <br />
                <Button
                  content="调整Exp"
                  onClick={() =>
                    act('adj_exp', {
                      skill: skill.path,
                    })
                  }
                />
                <Button
                  content="设定Exp"
                  onClick={() =>
                    act('set_exp', {
                      skill: skill.path,
                    })
                  }
                />
                <Button
                  content="设定等级"
                  onClick={() =>
                    act('set_lvl', {
                      skill: skill.path,
                    })
                  }
                />
                <br />
                <br />
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

const Level = (props) => {
  const { skill_lvl_num, skill_lvl } = props;
  return (
    <Box inline>
      等级: [
      <Box inline bold textColor={`hsl(${skill_lvl_num * 50}, 50%, 50%)`}>
        {skill_lvl}
      </Box>
      ]
    </Box>
  );
};
