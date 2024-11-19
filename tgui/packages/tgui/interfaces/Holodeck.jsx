import { useBackend } from '../backend';
import { Button, Section } from '../components';
import { Window } from '../layouts';

export const Holodeck = (props) => {
  const { act, data } = useBackend();
  const { can_toggle_safety, emagged, program } = data;
  const default_programs = data.default_programs || [];
  const emag_programs = data.emag_programs || [];
  return (
    <Window width={400} height={500}>
      <Window.Content scrollable>
        <Section
          title="默认场景程序"
          buttons={
            <Button
              icon={emagged ? 'unlock' : 'lock'}
              content="安全保险"
              color="bad"
              disabled={!can_toggle_safety}
              selected={!emagged}
              onClick={() => act('safety')}
            />
          }
        >
          {default_programs.map((def_program) => (
            <Button
              fluid
              key={def_program.id}
              content={def_program.name.substring(11)}
              textAlign="center"
              selected={def_program.id === program}
              onClick={() =>
                act('load_program', {
                  id: def_program.id,
                })
              }
            />
          ))}
        </Section>
        {!!emagged && (
          <Section title="危险场景程序">
            {emag_programs.map((emag_program) => (
              <Button
                fluid
                key={emag_program.id}
                content={emag_program.name.substring(11)}
                color="bad"
                textAlign="center"
                selected={emag_program.id === program}
                onClick={() =>
                  act('load_program', {
                    id: emag_program.id,
                  })
                }
              />
            ))}
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
