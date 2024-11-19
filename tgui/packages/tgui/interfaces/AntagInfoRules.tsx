// THIS IS A SKYRAT UI FILE
import { useBackend } from '../backend';
import { Stack } from '../components';
import { Objective } from './common/Objectives';

type Info = {
  antag_name: string;
  objectives: Objective[];
};

export const Rules = (props) => {
  const { data } = useBackend<Info>();
  const { antag_name } = data;
  switch (antag_name) {
    case 'Abductor Agent' || 'Abductor Scientist' || 'Abductor Solo':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Abductors!_Station_Threat">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
      break;
    case 'Drifting Contractor':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Contractor!">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
      break;
    case 'Cortical Borer':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Cortical_Borer!_PERMANENT_MECHANICAL_STATE">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
      break;
    case 'Venus Human Trap':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Man_Eaters!_PERMANENT_MECHANICAL_STATE">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
      break;
    case 'Obsessed':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Obsessed!">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
      break;
    case 'Revenant':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Revenant!_PERMANENT_MECHANICAL_STATE">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
      break;
    case 'Space Dragon':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Space_Dragon!_PERMANENT_MECHANICAL_STATE">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
      break;
    case 'Space Pirate':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Space_Pirates!_Station_Threat">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
      break;
    case 'Blob':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Blob!_PERMANENT_MECHANICAL_STATE">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
      break;
    case 'Changeling':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Changeling!_Station_Threat">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
    case 'ClockCult':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Clockcult_(OPFOR)">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
    case 'AssaultOps':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Assault_Ops!">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
    case 'Heretic':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Heretic!">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
    case 'Malf AI':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Malf_AI!">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
    case 'Morph':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Morphling!_Station_Threat">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
    case 'Nightmare':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Nightmare!_Station_Threat">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
    case 'Ninja':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Space_Ninja">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
    case 'Wizard':
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Wizard!">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
    default:
      return (
        <Stack vertical>
          <Stack.Item bold>特殊规则:</Stack.Item>
          <Stack.Item>
            {
              <a href="https://wiki.skyrat13.space/index.php/Antagonist_Policy#Traitor!">
                特殊规则以及游戏外保护机制!
              </a>
            }
          </Stack.Item>
        </Stack>
      );
      break;
  }
};
