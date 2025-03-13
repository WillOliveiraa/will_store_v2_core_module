abstract class Mapper<Entity, Model> {
  Entity toEntity(Model model);
  Model toModel(Entity entity);
}
