class FormFieldController<T> {
  FormFieldController(this.value);

  T? value;

  void reset() {
    value = null;
  }
}
