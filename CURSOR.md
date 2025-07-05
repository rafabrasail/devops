## Project Context: 
This project is to procuce a self hosted agent in docker container to deploy in another docekr container a React application. 

## Objectives
Develop an efficiente agent to deploy the application
Containerize the application using Docker.
Implement cursor guidelines (CURSORDEV-NOTE, CURSORDEV-TODO, CURSORDEV-NO_AI) to manage AI-assisted coding.

## The Golden Rule  
When unsure about implementation details, ALWAYS ask the developer.  
Aim for the simplest solution possible

## Notes: attention to signs inline code:
 - CURSORDEV-NOTE 
 - CURSORDEV-TODO 
 - CURSORDEV-NO_AI

 ## What AI Must NEVER Do  
1. **Never modify test files** - Tests encode human intent  
2. **Never change API contracts** - Breaks real applications  
3. **Never alter migration files** - Data loss risk  
4. **Never commit secrets** - Use environment variables  
5. **Never assume business logic** - Always ask  
6. **Never remove CURSORDEV- comments** - They're there for a reason 

## Code Style and Patterns  

### Anchor comments  

Add specially formatted comments throughout the codebase, where appropriate, for yourself as inline knowledge that can be easily `grep`ped for.  

### Guidelines:  

- Use `CURSORDEV-NOTE:`, `CURSORDEV-TODO:`, or `CURSORDEV-QUESTION:` (all-caps prefix) for comments aimed at AI and developers.  
- **Important:** Before scanning files, always first try to **grep for existing anchors** `CURSORDEV-*` in relevant subdirectories.  
- **Update relevant anchors** when modifying associated code.  
- **Do not remove `CURSORDEV-NOTE`s** without explicit human instruction.  
- AI Assistance: Use AI for generating boilerplate code (e.g., Django models, views, or Dockerfiles) but always tag with CURSOR-NOTE for review.
- Make sure to add relevant anchor comments, whenever a file or piece of code is:  
  * too complex, or  
  * very important, or  
  * confusing, or  
  * could have a bug

## Domain Glossary (Claude, learn these!)  

- **Agent**: AI entity with memory, tools, and defined behavior  
- **Task**: Workflow definition composed of steps (NOT a Celery task)  
- **Execution**: Running instance of a task  
- **Tool**: Function an agent can call (browser, API, etc.)  
- **Session**: Conversation context with memory  
- **Entry**: Single interaction within a session 